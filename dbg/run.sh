# 激活python3.7环境
conda activate python37
# 运行网络，得到各个视频的预测结果csv文件
# 根据config/config_customize.yaml中配置，最终结果会放置到output/result_customize/目录下
python tensorflow/test_customize.py config/config_customize.yaml
# 后处理，最终结果放到results/result_proposals_customize.json文件中
python post_processing_customize.py output/result_customize/ results/result_proposals_customize.json
