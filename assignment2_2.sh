
mod2_2 = {
    'Task1': {
        'd': 'System report file exist ~/backup/system-backup.info',
        'vc': "ls -l /home/$(who am i | awk '{print $1}')/backup/system-backup.info > /dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task2': {
        'd': 'The Fully Qualified Domain Name FQDN hostname of the system',
        'vc': "grep $(hostname -f) /home/$(who am i | awk '{print $1}')/backup/system-backup.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task3': {
        'd': 'The current date of the system',
        'vc': "grep \"$(date | awk '{print $(NF-1), $NF}')\" /home/$(who am i | awk '{print $1}')/backup/system-backup.info >/dev/null 2>&1; echo $? ",
        'r': 0,
        'p': 'eq',
    },
    'Task4': {
        'd': 'The uptime information of the system',
        'vc': "grep 'load average' /home/$(who am i | awk '{print $1}')/backup/system-backup.info >/dev/null 2>&1; echo $? ",
        'r': 0,
        'p': 'eq',
    }, 
    'Task5': {
        'd': 'Contains your lastname in the proper format',
        'vc': "grep 'LASTNAME' /home/$(who am i | awk '{print $1}')/backup/system-backup.info >/dev/null 2>&1; echo $? ",
        'r': 0,
        'p': 'eq',
    },
    'Task6': {
        'd': 'The internal content of the /etc/resolv.conf file',
        'vc': "grep 'nameserver' /home/$(who am i | awk '{print $1}')/backup/system-backup.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task7': {
        'd': 'The list of files in the folder /var/log/ sorted alphabetically.',
        'vc': "grep 'boot.log' /home/$(who am i | awk '{print $1}')/backup/system-backup.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task8': {
        'd': 'The report of file system space usage for the /home folder',
        'vc': "grep 'Filesystem' /home/$(who am i | awk '{print $1}')/backup/system-backup.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task9': {
        'd': 'The output of the ~apropos uname~ command without the word ~kernel~',
        'vc': "grep uname /home/$(who am i | awk '{print $1}')/backup/system-backup.info | grep kernel >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'ne',
    }, 
}