
mod2_7 = {
    'Task1': {
        'd': 'The cheese app must be uninstalled',
        'vc': "rpm -qa | grep cheese-[[:digit:]] >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'ne',
    },    
    'Task2': {
        'd': 'Apache must be installed',
        'vc': "rpm -qa | grep ^httpd-[[:digit:]] >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task3': {
        'd': 'Typora must be installed',
        'vc': "ls /opt/bin/T*/Typora >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task4': {
        'd': 'TuxPaint must be installed',
        'vc': "rpm -qa | grep tuxpaint >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task5': {
        'd': 'Created website',
        'vc': "grep -E \"Assignment 7|Learning Linux\" /var/www/html/index.html >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
}
# mod2_8 doesn't have checker database