#!/bin/bash
set -e

# Xóa server.pid cũ nếu tồn tại (tránh lỗi xung đột khi restart container)
rm -f /myapp/tmp/pids/server.pid

exec "$@"