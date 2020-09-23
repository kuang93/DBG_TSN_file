#coding=UTF-8
import os
import glob
import cv2
import argparse
import pandas as pd

def make_csv(vid_list,out_path):
    import cv2
    video_info =pd.DataFrame(columns=('video_name','numFrame','seconds'))
    for vid_path in vid_list:
        video = cv2.VideoCapture(vid_path)
        video_name = vid_path.split('/')[-1].split('.')[0]

        #获取总帧数
        numFrame = int(video.get(cv2.cv.CV_CAP_PROP_FRAME_COUNT))
        #获取帧率
        fps = int(round(video.get(cv2.cv.CV_CAP_PROP_FPS)))
        #计算时长
        seconds = numFrame / fps

        video.release()

        video_info=video_info.append(pd.DataFrame({'video_name':[video_name],'numFrame':[numFrame],'seconds':[seconds]}),sort=False)

    print('video_info path: {}'.format(out_path+'/video_info.csv'))
    video_info.to_csv(out_path+'/video_info.csv')

if __name__ == '__main__':
    print(cv2.__version__)
    parser = argparse.ArgumentParser(description='generate video information')
    parser.add_argument('src_dir')
    parser.add_argument('out_dir')
    parser.add_argument('--ext', type=str, default='avi', choices=['avi', 'mp4', 'mkv', 'webm'], help='video file extensions')

    args = parser.parse_args()

    src_path = args.src_dir
    out_path = args.out_dir

    if not os.path.isdir(out_path):
        print('creating folder: '+out_path)
        os.makedirs(out_path)
    print('reading videos from folder: ', src_path)

    print('select extensions of videos: avi, mp4, mkv, webm')
    vid_list = glob.glob(src_path+'/*.avi')
    vid_list.extend(glob.glob(src_path+'/*.mp4'))
    vid_list.extend(glob.glob(src_path+'/*.mkv'))
    vid_list.extend(glob.glob(src_path+'/*.webm'))
    print('total number of videos found: ', len(vid_list))
    
    #创建video_info.csv
    make_csv(vid_list,out_path)
