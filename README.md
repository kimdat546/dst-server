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