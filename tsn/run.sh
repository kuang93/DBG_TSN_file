export PYTHONPATH=../

# 生成视频的光流文件和逐帧图像文件，zip格式
# 输出的内容放到tsn/output_folder/1.video_optical_flow/目录下，gpu 1个 
bash tsn/extract_optical_flow.sh tsn/input_folder tsn/output_folder/1.video_optical_flow/ 1

# 使用anet2016提供的网络模型和参数，以上一步生成的光流和逐帧图像文件为输入，生成视频特征csv文件
# 输出的内容放到tsn/output_folder/2.tsn_anet2016_score_5fps/spatial/
# 和tsn/output_folder/2.tsn_anet2016_score_5fps/temporal/ 目录下
# anet2016
python tsn/eval_net_zip.py activitynet_1.3 1 rgb tsn/output_folder/1.video_optical_flow/ tsn/models/resnet200_anet_2016_deploy.prototxt tsn/models/resnet200_anet_2016.caffemodel --num_worker 1 --gpus 0 --save_scores tsn/output_folder/2.tsn_anet2016_score_5fps/spatial/
python tsn/eval_net_zip.py activitynet_1.3 1 flow tsn/output_folder/1.video_optical_flow/  tsn/models/bn_inception_anet_2016_temporal_deploy.prototxt tsn/models/bn_inception_anet_2016_temporal.caffemodel.v5 --num_worker 1 --gpus 0 --save_scores tsn/output_folder/2.tsn_anet2016_score_5fps/temporal/

# 生成video_info.csv, 包含视频名称、帧数和时长（秒）
python tsn/gen_video_info.py tsn/input_folder/ tsn/output_folder/

# 将上述生成的视频特征进行rescale
# 生成的内容放到tsn/output_folder/3.all_csv_mean_100/ 目录下
# 生成tsn_anet_anno_100.json
python tsn/data_process.py tsn/output_folder/2.tsn_anet2016_score_5fps/ tsn/output_folder/3.all_csv_mean_100 tsn/output_folder/video_info.csv --out_json_file tsn/output_folder/tsn_anet_anno_100.json
