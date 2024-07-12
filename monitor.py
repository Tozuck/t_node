import psutil  # Import the psutil module for system and process utilities
import time    # Import the time module for time-related functions

# Function to get CPU usage percentage
def get_cpu_usage():
    return psutil.cpu_percent(interval=1)

# Function to get network bandwidth usage in Mbps
def get_bandwidth_usage():
    # Get network bytes received and sent per second
    net_io = psutil.net_io_counters()
    bytes_recv = net_io.bytes_recv
    bytes_sent = net_io.bytes_sent
    
    # Convert bytes to bits (1 byte = 8 bits)
    bits_recv = bytes_recv * 8
    bits_sent = bytes_sent * 8

    # Calculate bandwidth in Mbps
    mbps_recv = bits_recv / 1e6  # 1e6 is 10^6
    mbps_sent = bits_sent / 1e6

    return mbps_recv, mbps_sent

# Function to calculate and return live data transfer speed in Mbps
def get_live_data_transfer_speed(last_bytes_recv, last_bytes_sent, last_time):
    # Get current network bytes received and sent per second
    net_io = psutil.net_io_counters()
    current_bytes_recv = net_io.bytes_recv
    current_bytes_sent = net_io.bytes_sent

    # Calculate elapsed time since last check
    current_time = time.time()
    elapsed_time = current_time - last_time

    # Calculate data transferred since last check in bytes
    data_recv = current_bytes_recv - last_bytes_recv
    data_sent = current_bytes_sent - last_bytes_sent

    # Calculate data transfer speed in Mbps
    speed_recv = (data_recv * 8) / (elapsed_time * 1e6)  # Mbps
    speed_sent = (data_sent * 8) / (elapsed_time * 1e6)  # Mbps

    return speed_recv, speed_sent, current_bytes_recv, current_bytes_sent, current_time

# Function to update the text file with CPU usage, bandwidth usage, live data transfer speed, total downloaded, and total uploaded
def update_stats_file():
    global last_bytes_recv, last_bytes_sent, last_time, total_recv, total_sent
    cpu_usage = get_cpu_usage()
    mbps_recv, mbps_sent = get_bandwidth_usage()
    speed_recv, speed_sent, last_bytes_recv, last_bytes_sent, last_time = get_live_data_transfer_speed(last_bytes_recv, last_bytes_sent, last_time)

    # Calculate usage per second in Mbps
    usage_per_sec_recv = speed_recv
    usage_per_sec_sent = speed_sent

    # Update total received and sent bytes
    total_recv += speed_recv
    total_sent += speed_sent

    with open('/var/www/html/file.txt', 'w') as file:
        file.write(f"cpu usage = {cpu_usage}%\n")
        file.write(f"network usage speed per sec receive = {usage_per_sec_recv:.2f} Mbps\n")
        file.write(f"total network usage downloaded = {total_recv:.2f} Mbps\n")
        file.write(f"total network usage uploaded = {total_sent:.2f} Mbps\n")

# Initialize variables for the first run
last_bytes_recv = 0
last_bytes_sent = 0
last_time = time.time()
total_recv = 0
total_sent = 0

# Main loop to update stats every second
if __name__ == "__main__":
    while True:
        update_stats_file()
        time.sleep(1)  # Update every second
