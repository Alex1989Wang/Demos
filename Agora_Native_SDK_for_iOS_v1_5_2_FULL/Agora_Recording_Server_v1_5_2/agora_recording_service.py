# !/usr/bin/env python
# coding=utf-8
import sys
reload(sys)
sys.setdefaultencoding('utf8')
import subprocess
import os
import tempfile
import tornado.httpserver
import tornado.ioloop
import tornado.web
import time
import traceback
import hmac
from hashlib import sha1
import urllib
import logging
import ctypes
import signal
from tornado import gen, locks

FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
logging.basicConfig(format=FORMAT)
logger = logging.getLogger('web')
logger.setLevel(logging.INFO)


def generateSignaure(staticKey, signKey, channelName, unixTs, randomInt):
    key = "\x00" * (32 - len(staticKey)) + staticKey
    content = key +\
        '{:0>10}'.format(unixTs) + \
        "%.8x" % (int(randomInt)) + \
        str(channelName)
    signature = hmac.new(signKey, content, sha1).hexdigest()
    return signature


def generateDynamicKey(staticKey, signKey, channelName, unixTs, randomInt):
    signature = generateSignaure(
        staticKey,
        signKey,
        channelName,
        unixTs,
        randomInt)
    ret = str(signature) + \
        staticKey + \
        '{0:0>10}'.format(unixTs) + \
        "%.8x" % (int(randomInt))
    return ret


def generateSignature4(
        staticKey,
        signKey,
        channelName,
        unixTs,
        randomInt,
        uid,
        expiredTs,
        servicetype):
    key = "\x00" * (32 - len(staticKey)) + staticKey
    content = servicetype + key +\
        '{:0>10}'.format(unixTs) + \
        "%.8x" % (int(randomInt)) + \
        str(channelName) +\
        '{:0>10}'.format(uid) + \
        '{:0>10}'.format(expiredTs)
    signature = hmac.new(signKey, content, sha1).hexdigest()
    return signature


def parseToken(token):
    version = token[:3]
    signature = token[3:43]
    vendorKey = token[43:75]
    unixTs = int(token[75:85])
    randomInt = int("0x%s" % (token[85:93]), 16)
    expiredTs = int(token[93:103])
    return (version, signature, unixTs, randomInt, expiredTs)


def verify_ticket(paths):
    # channelName = urllib.unquote_plus(paths[3])
    channelName = paths[3]
    uid = int(paths[4])
    uid = ctypes.c_uint(uid).value
    (version, signature, unixTs, randomInt,
        expiredTs) = parseToken(paths[5])
    if version == "004":
        now = int(time.time())
        # if unixTs + TIMEOUT < now:
        # raise Exception(
        # "unixTs expired now : %d unixTs: %d" %
        # (now, unixTs))
        logger.info(
            "%s %s %s %s %s %s %s" %
            (VENDORKEY,
                VENDORSIGN,
                channelName,
                unixTs,
                randomInt,
                uid,
                expiredTs))
        gen = generateSignature4(
            VENDORKEY,
            VENDORSIGN,
            channelName,
            unixTs,
            randomInt,
            uid,
            expiredTs, "ARS")
        if gen != signature:
            raise Exception("token diff %s %s" % (gen, signature))
    else:
        raise Exception("version error %s" % version)


class Process(object):

    def __init__(self):
        self.process = None
        self.process_lock = locks.Lock()


class DataHub(object):

    def __init__(self):
        self.processes = {}
        self.lock = locks.Lock()

    def getProcess(self, cname):
        p = None
        self.lock.acquire()
        if cname not in self.processes:
            self.processes[cname] = Process()
        p = self.processes[cname]
        self.lock.release()
        return p


dataHub = DataHub()


def getPid(channelName):
    for pid in os.listdir('/proc'):
        if not pid.isdigit():
            continue
        try:
            with open('/proc/{}/cmdline'.format(pid), mode='rb') as fd:
                content = fd.read().decode().split('\x00')
        except Exception:
            continue
        if len(content) >= 7:
            if channelName == str(content[4]) and \
                    "./agora_recording.exe" == str(content[0]):
                return pid
    return None


def start(channelName):
    p = dataHub.getProcess(channelName)
    logger.info("start %s %s" % (channelName, p))
    p.process_lock.acquire()
    ret = 0
    if p.process and p.process.poll() is None and getPid(channelName):
        ret = 1
    else:
        dkey = generateDynamicKey(
            VENDORKEY, VENDORSIGN, channelName, int(
                time.time()), 0)
        cmd = "AGORA_FILE_ROOT=%s LD_LIBRARY_PATH=. ./agora_recording.exe --key %s "\
            " --name '%s' --uid %s >>avr.log 2>&1" % \
            (AGORA_FILE_ROOT , dkey, channelName, int(time.time() * 1000))
        logger.info("%s" % cmd)
        p.process = subprocess.Popen(cmd, shell=True)
        if p.process.poll() is None and getPid(channelName):
            ret = 1
        else:
            ret = 0
    p.process_lock.release()
    return ret


def stop(channelName):
    p = dataHub.getProcess(channelName)
    logger.info("stop %s %s" % (channelName, p))
    p.process_lock.acquire()
    # with (yield p.process_lock.acquire()):
    if p.process and p.process.poll() is None:
        p.process.terminate()
        p.process.wait()
        pid = getPid(channelName)
        if pid:
            os.kill(int(pid), signal.SIGTERM)
        logger.info("stoped %s %s" % (pid, p.process.poll()))
    p.process_lock.release()


def status(channelName):
    p = dataHub.getProcess(channelName)
    ret = 0
    p.process_lock.acquire()
    # with (yield p.process_lock.acquire()):
    if p.process and p.process.poll() is None:
        ret = 1
    else:
        ret = 0
    p.process_lock.release()
    return ret


class MainHandler(tornado.web.RequestHandler):

    def initialize(self):
        self.set_header("Access-Control-Allow-Origin", "*")

    @gen.coroutine
    def get(self, url):
        ret = ''
        startTs = time.time()
        logger.info("%s" % (url))
        try:
            paths = url.split("/")
            path = "/%s/%s/%s" % (paths[0], paths[1], paths[2])
            # channelName = urllib.unquote_plus(paths[3])
            channelName = paths[3]
            # cmd = "./op_record.sh %s %s %s" % (paths[2], VENDORKEY, channelName)
            if path == "/agora/recording/start":
                verify_ticket(paths)
                ret = start(channelName)
            elif path == "/agora/recording/stop":
                verify_ticket(paths)
                ret = stop(channelName)
            elif path == "/agora/recording/status":
                ret = status(channelName)
            else:
                raise Exception('path error:%s' % path)
            self.set_status(200)
        except:
            self.set_status(500)
            traceback.print_exc()
        finally:
            logger.info("%s return %s takes %d ms" %
                        (url, ret, int((time.time() - startTs) * 1000)))
            self.finish(str(ret))

VENDORKEY = os.environ.get('VENDORKEY', '')
VENDORSIGN = os.environ.get('VENDORSIGN', 'agora_vendor_recording_signature')
TIMEOUT = os.environ.get('TIMEOUT', 3600)
PORT = os.environ.get('PORT', 8001)
AGORA_FILE_ROOT=os.environ.get('AGORA_FILE_ROOT', "./")


if __name__ == "__main__":
    application = tornado.web.Application([
        (r"/(.*)", MainHandler),
    ])
    application.listen(PORT)
    tornado.ioloop.IOLoop.instance().start()
