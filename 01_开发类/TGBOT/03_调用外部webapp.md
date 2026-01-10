```python

import json
import ults.read_config 
from telegram import KeyboardButton, ReplyKeyboardMarkup, Update,ReplyKeyboardRemove,WebAppInfo
from telegram.ext import Application,ContextTypes,MessageHandler,filters,CommandHandler
HASH, TOKEN , PROXY = ults.read_config.read_bot_config()


#发送一个按钮打开URL
async def start(update:Update,context:ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        text="选择一个按钮",
        reply_markup=ReplyKeyboardMarkup.from_button(
            KeyboardButton(
                text="点击按钮访问web",
                web_app=WebAppInfo(url="https://python-telegram-bot.org/static/webappbot"),
            )
        ),
    )

async def web_app_data(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    #获取小程序数据
    data = json.loads(update.effective_message.web_app_data.data)
    #更新资源
    await update.message.reply_html(
        text=(
            f"You selected the color with the HEX value <code>{data['hex']}</code>. The "
            f"corresponding RGB value is <code>{tuple(data['rgb'].values())}</code>."
        ),
        reply_markup=ReplyKeyboardRemove(),
    )

def init_bot():
    app = (Application.builder()
        .token(TOKEN)
        .proxy(PROXY)
        .get_updates_proxy(PROXY)
        .build()
    )
    app.add_handler(CommandHandler("start", start))
    app.add_handler(MessageHandler(filters.StatusUpdate.WEB_APP_DATA, web_app_data))
    # Run the bot until the user presses Ctrl-C
    app.run_polling()



```

主要是通过url访问 点击按钮并且返回后端数据