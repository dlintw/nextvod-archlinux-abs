dd if=/dev/zero bs=1M count=500 of=/swapfile \
&& mkswap /swapfile \
&& swapon /swapfile \
&& free
