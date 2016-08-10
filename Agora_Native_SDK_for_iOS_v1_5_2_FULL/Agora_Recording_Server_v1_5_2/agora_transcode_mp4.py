import sys
import os
import subprocess
import datetime
from time import sleep

def nowString():
	return '{0:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now())

def isTranscodeRunning():
	x = subprocess.Popen('ps aux | grep ffmpeg | grep -v grep', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	return len(x.stdout.readlines()) != 0

def isffmpegReady():
	x = subprocess.Popen('which ffmpeg', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	return len(x.stdout.readlines()) != 0

def listFolderByDate(rootDir, howManyDays):
	folderList = []
	if rootDir.endswith('/') == False:
		rootDir += '/'

	if os.path.isdir(rootDir) == False:	
		return folderList
	
	today = datetime.date.today()
	for i in range(0, howManyDays):
		dateStr = (today - datetime.timedelta(days=i)).strftime('%Y%m%d')
		folderList.append('{0}{1}/'.format(rootDir, dateStr))

	return folderList

def listFilePath(rootDir, isDir=False, endswith=''):
	paths = ['{0}{1}'.format(rootDir, x) for x in os.listdir(rootDir) if os.path.isdir('{0}{1}'.format(rootDir, x)) == isDir]
	if isDir == False:
		paths = [x for x in paths if x.endswith(endswith)]
	else:
		paths = ['{0}/'.format(x) for x in paths]
	return paths


def transcodeThisClip(tmp):
	print('---> Transcode the video clip {0}'.format(tmp))
	
	mp4 = tmp.replace('.tmp', '.mp4')
	if os.path.exists(mp4):
		print '\n\t{0} is detected. Skip. \n\tPlease delete .mp4 file if you need re-transcode.'.format(mp4)
		return

	arf = tmp.replace('.tmp', '.arf')
	if os.path.exists(arf):
		print '\n\t{0} is detected. Skip. \n\t.arf is the middle file while transcoding is in progress.'.format(arf)
		return

	cmd = 'ffmpeg -i {0} -loglevel fatal -threads 2 -c:v libx264 -c:a copy -f mp4 {1}'.format(tmp, arf)
	print '\t{0}'.format(cmd)
	x = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	for log in x.stdout.readlines():
		print '[ffmpeg info] {0}'.format(log)
	for log in x.stderr.readlines():
		print '[ffmpeg error] {0}'.format(log)
	
	try:
		os.rename(arf, mp4)
	except Exception, e:
		print 'fail to rename {0} -> {1}. error: {2}'.format(arf, mp4, e)
		return

	print '\tSuccess! {0} -> {1}\n'.format(tmp, mp4)
	


def transcodeThisChannel(folder):
	print('''
    +---------------------------------------------------------------------
    | Channel {0}
    | Scan @{1}
    +---------------------------------------------------------------------
	'''.format(folder, nowString()))
	
	recordingStatusFile = '{0}recording-done.txt'.format(folder)
	if os.path.exists(recordingStatusFile) == False:
		print '\n\tWarning: No {0}. Recording files are not ready. Skip'.format(recordingStatusFile)
		return

	tmpFiles = listFilePath(folder, isDir=False, endswith='.tmp')
	for tmp in tmpFiles:
		transcodeThisClip(tmp)


def transcodeThisDay(folder):
	print('''
**************************************************************************
* Recorded on {0}
* Scan @{1}
* Author: Agora.io Recording & Playback Team, 2016
**************************************************************************
	'''.format(folder, nowString()));
		
	if os.path.isdir(folder) == False:
		print '\n\t Warning: path {0} cannot be found, ignore'.format(folder)
		return

	subFolders = listFilePath(folder, isDir = True)
	for sub in subFolders:
		transcodeThisChannel(sub)


def main():
	if len(sys.argv) != 2:
		print "\n\t Usage: python agora_video_record.py RECORDING_FILE_ROOT_PATH\n"
		return

	if isffmpegReady() == False:
		print "\n\t Error: fail to find ffmpeg by cmd 'which ffmpeg'.\n"

	if isTranscodeRunning() == True:
		print "\n\t Warning: Transcode is running. Please try next around\n"
		return

	folderList = listFolderByDate(sys.argv[1], 3)
	for folder in folderList:
		transcodeThisDay(folder)
		sleep(1)


if __name__ == '__main__':
	main()
