'''
作者: Xioaruan912 xioaruan@gmail.com
最后编辑人员: Xioaruan912 xioaruan@gmail.com
文件作用介绍: 

'''
# -*- coding:utf-8 -*-
from burp import IBurpExtender,IHttpListener
class BurpExtender(IBurpExtender,IHttpListener):
    def registerExtenderCallbacks(self, callbacks):
        self._callbacks = callbacks
        self._helpers = callbacks.getHelpers()
        callbacks.registerHttpListener(self)  #注册IhttpListener
        callbacks.setExtensionName(u"输出拦截请求")
    def GetResponseHeaderAndBody(self,messageInfo):
        #这个方法我们用于返回 响应的 body和 headers
        response = messageInfo.getResponse()
        response_ana_data = self._helpers.analyzeResponse(response)
        headers = list(response_ana_data.getHeaders())
        body = response[response_ana_data.getBodyOffset():].tostring()
        return headers,body
    def RePlaceStrBody(self,body):
        if "Cheery" in body:
            self._callbacks.printOutput("[+---+] Find key word ---> Cheery")
            body = body.replace("Cheery", 'Burp_attack')
            return body
    def processHttpMessage(self, toolFlag, messageIsRequest, messageInfo):
        if messageIsRequest:
            return
        headers ,body = self.GetResponseHeaderAndBody(messageInfo)
        self._callbacks.printOutput("[+] Find body before Change ---> {}".format(body))
        self._callbacks.printOutput("[+] Find headers before Change ---> {}".format(headers))
        body = self.RePlaceStrBody(body)
        new_message = self._helpers.buildHttpMessage(headers,body)
        messageInfo.setResponse(new_message)