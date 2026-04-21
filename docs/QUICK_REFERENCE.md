# AVM 视频拼接快速参考 (Quick Reference)

## 😀 30 秒快速上手

### 编译项目
```bash
cd AVM
./scripts/build.sh
```

### 处理图像（默认）
```bash
./build/bin/avm
```
输出: `build/stitched_result_with_su7.jpg`

### 处理视频（新功能）
```bash
# Linux/macOS/WSL2
./scripts/process_video.sh front.mp4 back.mp4 left.mp4 right.mp4

# Windows PowerShell
.\scripts\process_video.ps1 -Front front.mp4 -Back back.mp4 -Left left.mp4 -Right right.mp4
```
输出: `build/stitched_output.mp4`

---

## 📋 完整命令参考

### 1️⃣ 图像模式
```bash
./build/bin/avm
```
从 `assets/images/` 读取：front.png, back.png, left.png, right.png

### 2️⃣ 视频模式 (直接)
```bash
./build/bin/avm video <front> <back> <left> <right> [output]
```

**参数说明**:
| 参数 | 说明 | 示例 |
|------|------|------|
| `<front>` | 前置摄像头视频 | front.mp4 |
| `<back>` | 后置摄像头视频 | back.mp4 |
| `<left>` | 左置摄像头视频 | left.mp4 |
| `<right>` | 右置摄像头视频 | right.mp4 |
| `[output]` | 输出视频（可选） | output.mp4 |

**示例**:
```bash
# 基本用法
./build/bin/avm video front.mp4 back.mp4 left.mp4 right.mp4

# 指定输出
./build/bin/avm video front.mp4 back.mp4 left.mp4 right.mp4 output.mp4

# 使用相对路径
./build/bin/avm video videos/front.mp4 videos/back.mp4 videos/left.mp4 videos/right.mp4

# 使用绝对路径
./build/bin/avm video /data/front.mp4 /data/back.mp4 /data/left.mp4 /data/right.mp4
```

### 3️⃣ 脚本方式

#### Linux/macOS/WSL2
```bash
./scripts/process_video.sh front.mp4 back.mp4 left.mp4 right.mp4 [output.mp4]
```

#### Windows PowerShell
```powershell
.\scripts\process_video.ps1 -Front front.mp4 -Back back.mp4 -Left left.mp4 -Right right.mp4 [-Output output.mp4]
```

### 4️⃣ 帮助信息
```bash
./build/bin/avm help
```

---

## 🎯 常见场景

### 场景 1: 处理本地视频文件
```bash
./build/bin/avm video front.mp4 back.mp4 left.mp4 right.mp4 result.mp4
```

### 场景 2: 批量处理多个视频组
```bash
# 使用脚本处理多个视频集
./scripts/process_video.sh dataset1/front.mp4 dataset1/back.mp4 dataset1/left.mp4 dataset1/right.mp4 output1.mp4
./scripts/process_video.sh dataset2/front.mp4 dataset2/back.mp4 dataset2/left.mp4 dataset2/right.mp4 output2.mp4
```

### 场景 3: 创建测试视频
```bash
# 从单张图片创建短视频用于测试
ffmpeg -loop 1 -i front.png -c:v libx264 -t 10 -pix_fmt yuv420p front.mp4
ffmpeg -loop 1 -i back.png -c:v libx264 -t 10 -pix_fmt yuv420p back.mp4
ffmpeg -loop 1 -i left.png -c:v libx264 -t 10 -pix_fmt yuv420p left.mp4
ffmpeg -loop 1 -i right.png -c:v libx264 -t 10 -pix_fmt yuv420p right.mp4

./build/bin/avm video front.mp4 back.mp4 left.mp4 right.mp4 test_output.mp4
```

### 场景 4: 验证输出视频
```bash
# 查看输出视频信息
ffprobe build/stitched_output.mp4

# 播放输出视频
ffplay build/stitched_output.mp4

# 提取输出视频的第一帧
ffmpeg -i build/stitched_output.mp4 -vframes 1 output_frame.jpg
```

---

## ⚡ 性能优化

### 降低处理时间
1. 使用较低分辨率的输入视频
2. 调整输出分辨率（编辑源代码）
3. 在高性能机器上运行

### 降低输出文件大小
```bash
# 使用 FFmpeg 重新编码输出视频
ffmpeg -i build/stitched_output.mp4 -c:v libx264 -crf 28 compressed_output.mp4
```

---

## 🐛 快速故障排查

| 问题 | 解决方案 |
|------|--------|
| 视频无法打开 | 检查文件路径和格式 |
| 标定失败 | 确保首帧有清晰的标定板 |
| 输出为空 | 检查磁盘空间和权限 |
| 处理速度慢 | 降低输入分辨率或使用更强的机器 |
| 内存不足 | 处理较短的视频或分段处理 |

---

## 📁 文件位置

### 输入
```
./front.mp4        → 前置摄像头视频
./back.mp4         → 后置摄像头视频
./left.mp4         → 左置摄像头视频
./right.mp4        → 右置摄像头视频
```

### 输出（图像模式）
```
./build/stitched_result_with_su7.jpg  → 最终拼接结果
./build/bird_*.jpg                     → 各方向的鸟瞰图
./build/*_undis.jpg                    → 去畸变后的图像
```

### 输出（视频模式）
```
./build/stitched_output.mp4            → 默认输出位置
./custom_path/output.mp4               → 自定义输出位置
```

---

## 📊 输出规格

| 属性 | 值 |
|------|-----|
| 分辨率 | 1596×948 像素 |
| 编码 | H.264 (mp4v) |
| 帧率 | 与输入相同 |
| 文件格式 | MP4 |
| 注释 | 完整的 360° 全景拼接 |

---

## 💡 提示和技巧

1. **同步视频**：确保四路视频的时间同步，最佳结果。

2. **标定板位置**：首帧中的标定板应该清晰可见，位于图像的中央区域。

3. **批处理**：
   ```bash
   for i in {1..10}; do
     ./build/bin/avm video videos/set_$i/front.mp4 videos/set_$i/back.mp4 videos/set_$i/left.mp4 videos/set_$i/right.mp4 output_$i.mp4
   done
   ```

4. **监控进度**：处理过程中会每 30 帧输出一次进度信息。

5. **调试**：查看完整的处理日志来诊断问题：
   ```bash
   ./build/bin/avm video ... 2>&1 | tee processing.log
   ```

---

## 📖 详细文档

- [VIDEO_STITCHING.md](docs/VIDEO_STITCHING.md) - 完整的视频拼接指南
- [INSTALLATION.md](docs/INSTALLATION.md) - 安装和配置
- [TECHNICAL_SPECS.md](docs/TECHNICAL_SPECS.md) - 技术规格
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - 实现细节

---

## 🆘 获取帮助

```bash
# 查看命令行帮助
./build/bin/avm help

# 查看处理脚本帮助
./scripts/process_video.sh  # (不带参数)
./scripts/process_video.ps1 -?  # (PowerShell)
```

---

## ✅ 检查清单

处理视频前：
- [ ] 确保已编译项目
- [ ] 验证四个视频文件存在
- [ ] 检查视频格式是否支持
- [ ] 确保磁盘空间充足（每分钟需要 ~200MB）
- [ ] 验证视频已同步

处理视频后：
- [ ] 检查输出文件是否生成
- [ ] 验证输出文件大小合理
- [ ] 播放输出视频检查质量
- [ ] 检查 FPS 和分辨率是否正确

---

**最后更新**: 2026-04-21  
**版本**: 1.0  
**支持的平台**: Linux, macOS, Windows (WSL2)
