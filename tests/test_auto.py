"""Run on Windows: python -m unittest discover -s tests -v (local repositories only)."""
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'Auto.bat'


class AutoTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='blog-auto-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.remote = self.root / 'remote.git'
        self.repo = self.root / '中文 notes !'
        self.git(self.root, 'init', '--bare', str(self.remote))
        self.git(self.root, 'clone', str(self.remote), str(self.repo))
        self.git(self.repo, 'config', 'user.name', 'Test')
        self.git(self.repo, 'config', 'user.email', 'test@example.invalid')
        self.git(self.repo, 'checkout', '-b', 'notes')
        (self.repo / 'note.md').write_text('base\n')
        self.git(self.repo, 'add', '.')
        self.git(self.repo, 'commit', '-m', 'base')
        self.git(self.repo, 'push', '-u', 'origin', 'notes')
        shutil.copyfile(SCRIPT, self.repo / 'Auto.bat')
        with (self.repo / '.git/info/exclude').open('a') as f:
            f.write('\nAuto.bat\n')

    def git(self, cwd, *args):
        p = subprocess.run(['git', '-C', str(cwd), *args], capture_output=True, encoding='utf-8', errors='replace')
        self.assertEqual(p.returncode, 0, p.stderr)
        return p.stdout.strip()

    def run_auto(self, *args, expected=0):
        p = subprocess.run(['cmd', '/d', '/c', 'Auto.bat', '--no-pause', *args], cwd=self.repo,
                           input='', capture_output=True, encoding='utf-8', errors='replace', timeout=30)
        self.assertEqual(p.returncode, expected, p.stdout + p.stderr)
        return p.stdout

    def test_clean_worktree_pushes_existing_commit(self):
        self.git(self.repo, 'commit', '--allow-empty', '-m', 'pending')
        self.run_auto('--yes')
        self.assertEqual(self.git(self.repo, 'rev-parse', 'HEAD'), self.git(self.remote, 'rev-parse', 'notes'))

    def test_check_preserves_untracked_files(self):
        before = self.git(self.repo, 'rev-parse', 'HEAD')
        (self.repo / '中文 ! & note.md').write_text('new')
        self.run_auto('--check')
        self.assertEqual(before, self.git(self.repo, 'rev-parse', 'HEAD'))
        self.assertTrue(self.git(self.repo, 'status', '--porcelain').startswith('??'))

    def test_commit_chinese_file(self):
        (self.repo / '中文 ! & note.md').write_text('new')
        self.run_auto('--yes')
        self.assertEqual('', self.git(self.repo, 'status', '--porcelain'))
        self.assertEqual(self.git(self.repo, 'rev-parse', 'HEAD'), self.git(self.remote, 'rev-parse', 'notes'))

    def test_line_ending_warning_is_not_a_conflict(self):
        self.git(self.repo, 'config', 'core.autocrlf', 'true')
        self.git(self.repo, 'config', 'core.safecrlf', 'warn')
        (self.repo / 'note.md').write_bytes(b'changed\n')
        self.run_auto('--yes')
        self.assertEqual(self.git(self.repo, 'rev-parse', 'HEAD'), self.git(self.remote, 'rev-parse', 'notes'))

    def test_detached_head_fails(self):
        self.git(self.repo, 'checkout', '--detach')
        self.run_auto('--yes', expected=1)

    def test_failed_fetch_keeps_worktree(self):
        before = self.git(self.repo, 'rev-parse', 'HEAD')
        (self.repo / 'new.md').write_text('new')
        self.git(self.repo, 'remote', 'set-url', 'origin', str(self.root / 'missing.git'))
        self.run_auto('--yes', expected=1)
        self.assertEqual(before, self.git(self.repo, 'rev-parse', 'HEAD'))
        self.assertTrue(self.git(self.repo, 'status', '--porcelain').startswith('??'))

    def peer_commit(self, filename='remote.md', content='remote\n'):
        peer = self.root / 'peer'
        self.git(self.root, 'clone', '-b', 'notes', str(self.remote), str(peer))
        self.git(peer, 'config', 'user.name', 'Peer')
        self.git(peer, 'config', 'user.email', 'peer@example.invalid')
        (peer / filename).write_text(content)
        self.git(peer, 'add', '.')
        self.git(peer, 'commit', '-m', 'remote change')
        self.git(peer, 'push')

    def test_clean_worktree_fast_forwards(self):
        self.peer_commit()
        self.run_auto('--yes')
        self.assertEqual('remote\n', (self.repo / 'remote.md').read_text())
        self.assertEqual(self.git(self.repo, 'rev-parse', 'HEAD'), self.git(self.remote, 'rev-parse', 'notes'))

    def test_diverged_history_rebases_and_backs_up(self):
        self.peer_commit()
        (self.repo / 'local.md').write_text('local')
        self.run_auto('--yes')
        self.assertTrue((self.repo / 'remote.md').exists())
        self.assertTrue((self.repo / 'local.md').exists())
        self.assertTrue(self.git(self.repo, 'for-each-ref', '--format=%(refname)', 'refs/auto-backup/'))
        self.assertEqual(self.git(self.repo, 'rev-parse', 'HEAD'), self.git(self.remote, 'rev-parse', 'notes'))

    def test_conflict_stops_push_and_allows_abort(self):
        self.peer_commit('note.md', 'remote\n')
        remote_head = self.git(self.remote, 'rev-parse', 'notes')
        (self.repo / 'note.md').write_text('local\n')
        self.run_auto('--yes', expected=1)
        self.assertEqual(remote_head, self.git(self.remote, 'rev-parse', 'notes'))
        self.assertTrue(self.git(self.repo, 'diff', '--name-only', '--diff-filter=U'))
        self.git(self.repo, 'rebase', '--abort')
        self.assertEqual('local\n', (self.repo / 'note.md').read_text())

    def test_new_branch_uses_its_own_name(self):
        self.git(self.repo, 'checkout', '-b', 'new-notes')
        self.run_auto('--yes')
        self.assertEqual(self.git(self.repo, 'rev-parse', 'HEAD'), self.git(self.remote, 'rev-parse', 'new-notes'))

    def test_upstream_with_different_name(self):
        self.git(self.repo, 'branch', '-m', 'local-name')
        self.git(self.repo, 'commit', '--allow-empty', '-m', 'pending')
        self.run_auto('--yes')
        self.assertEqual(self.git(self.repo, 'rev-parse', 'HEAD'), self.git(self.remote, 'rev-parse', 'notes'))


if __name__ == '__main__':
    unittest.main()
