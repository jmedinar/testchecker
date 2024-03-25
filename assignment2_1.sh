
mod2_1 = {
    'Task1': {
        'd': 'At least 2 GB of Memory',
        'vc': "grep MemTotal /proc/meminfo | awk '{print $2}'",
        'r': 2000000,
        'p': 'gt',
    },
    'Task2': {
        'd': 'One Virtual Disk of at least 20 GB of size (Fixed size)',
        'vc': "fdisk -s $(df / | tail -1 | awk '{print $1}')",
        'r': 20000000,
        'p': 'gt',
    },
    'Task3': {
        'd': 'At least 1 CPU',
        'vc': "ls", #"lscpu | grep -E '^CPU\(s\):' | awk '{print $NF}'",
        'r': 1,
        'p': 'gt',
    },
    'Task4': {
        'd': 'Make sure the Virtual Machine can reach the Internet',
        'vc': "ping www.collin.edu -c1 1>/dev/null; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task5': {
        'd': 'At installation, change the hostname to "server.lab" under the network settings',
        'vc': "hostname -f",
        'r': "server.lab",
        'p': 'get',
    }, 
}