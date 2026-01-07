# DST Server Setup

Server Don't Starve Together chạy 24/24 với Docker và Coolify.

## Setup
1. Lấy Cluster Token từ game
2. Deploy lên Coolify
3. Thêm CLUSTER_TOKEN vào Environment Variables
```

### **Bước 3: Deploy lên Coolify**

1. **Đăng nhập Coolify**
   - Truy cập: `http://YOUR_VPS_IP:8000`

2. **Tạo Project mới** (nếu chưa có)
   - Click **New Project**
   - Đặt tên: `Game Servers`

3. **Add Resource**
   - Click **+ New Resource**
   - Chọn **Public Repository** (hoặc Private nếu repo của bạn là private)

4. **Configure Repository**
   - **Git Repository URL**: Paste URL repo GitHub của bạn
   - Click **Continue**

5. **Select Build Pack**
   - **Build Pack**: Chọn **Docker Compose**
   - **Branch**: `main` hoặc `master`
   - **Docker Compose Location**: `docker-compose.yml` (mặc định)
   - Click **Continue**

6. **Configure Ports** 
   - **QUAN TRỌNG**: Với game server, Coolify sẽ tự động detect ports từ docker-compose.yml
   - **KHÔNG cần** assign domain cho service này (vì là game server UDP)

7. **Environment Variables**
   - Click vào tab **Environment Variables**
   - Add variable:
```
     Key: CLUSTER_TOKEN
     Value: pds-g^xxxxx-q^yyyyyy= (token của bạn)

command copy mods từ mac

```
cp -r '/Users/kimdat546/Library/Application Support/Steam/steamapps/workshop/content/322330/1852257480' ./mods/workshop-1852257480
cp -r '/Users/kimdat546/Library/Application Support/Steam/steamapps/workshop/content/322330/786556008' ./mods/workshop-786556008
cp -r '/Users/kimdat546/Library/Application Support/Steam/steamapps/workshop/content/322330/375850593' ./mods/workshop-375850593
cp -r '/Users/kimdat546/Library/Application Support/Steam/steamapps/workshop/content/322330/374550642' ./mods/workshop-374550642
cp -r '/Users/kimdat546/Library/Application Support/Steam/steamapps/workshop/content/322330/380423963' ./mods/workshop-380423963
cp -r '/Users/kimdat546/Library/Application Support/Steam/steamapps/workshop/content/322330/501385076' ./mods/workshop-501385076
cp -r '/Users/kimdat546/Library/Application Support/Steam/steamapps/workshop/content/322330/666155465' ./mods/workshop-666155465
cp -r '/Users/kimdat546/Library/Application Support/Steam/steamapps/workshop/content/322330/1207269058' ./mods/workshop-1207269058
cp -r '/Users/kimdat546/Library/Application Support/Steam/steamapps/workshop/content/322330/362175979' ./mods/workshop-362175979
```