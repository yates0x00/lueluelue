# 确保配置如下（关键是 sleep_delay >= 3 秒）
Delayed::Worker.sleep_delay = 5  # 无任务时睡眠 5 秒，再唤醒检查（默认值，必须设）
Delayed::Worker.max_attempts = 3  # 避免任务失败无限重试
Delayed::Worker.max_run_time = 5.minutes  # 防止任务卡死
Delayed::Worker.read_ahead = 10  # 可选：预读任务数，减少查询次数

