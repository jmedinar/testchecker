
mod2_3 = {
    'Task1': {
        'd': 'Verify /opt/enterprise-app exist',
        'vc': "ls -d /opt/enterprise-app >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task2': {
        'd': 'Verify /opt/enterprise-app/bin exist',
        'vc': "ls -d /opt/enterprise-app/bin >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task3': {
        'd': 'Verify /opt/enterprise-app/code exist',
        'vc': "ls -d /opt/enterprise-app/code >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task4': {
        'd': 'Verify /opt/enterprise-app/docs exist',
        'vc': "ls -d /opt/enterprise-app/docs >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task5': {
        'd': 'Verify /opt/enterprise-app/flags exist',
        'vc': "ls -d /opt/enterprise-app/flags >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task6': {
        'd': 'Verify /opt/enterprise-app/libs exist',
        'vc': "ls -d /opt/enterprise-app/libs >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task7': {
        'd': 'Verify /opt/enterprise-app/logs exist',
        'vc': "ls -d /opt/enterprise-app/logs >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task8': {
        'd': 'Verify /opt/enterprise-app/scripts exist',
        'vc': "ls -d /opt/enterprise-app/scripts >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    #----------------------------------------------------------------------
    'Task9': {
        'd': 'root is the owner of the enterprise-app folder',
        'vc': "stat -c %U /opt/enterprise-app/ 2>/dev/null",
        'r': "root",
        'p': 'get',
    }, 
    'Task10': {
        'd': 'regular user account owns all the other folders',
        'vc': "ls -l /opt/enterprise-app/ | grep root >/dev/null 2>&1; echo $?",
        'r': 1,
        'p': 'eq',
    }, 
    'Task11': {
        'd': 'Verify bin/app.py file exist',
        'vc': "ls /opt/enterprise-app/bin/app.py >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task12': {
        'd': 'Verify logs/stdout.log exist',
        'vc': "ls /opt/enterprise-app/logs/stdout.log >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task13': {
        'd': 'Verify logs/stderr.log exist',
        'vc': "ls /opt/enterprise-app/logs/stderr.log >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task14': {
        'd': 'Verify docs/README.txt exist',
        'vc': "ls /opt/enterprise-app/docs/README.txt >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task15': {
        'd': 'Verify scripts/clean.sh exist',
        'vc': "ls /opt/enterprise-app/scripts/clean.sh >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task16': {
        'd': 'Verify flags/pid.info exist',
        'vc': "ls /opt/enterprise-app/flags/pid.info >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    #----------------------------------------------------------------------------
    'Task17': {
        'd': 'Permissions of scripts/clean.sh',
        'vc': "stat -c %a /opt/enterprise-app/scripts/clean.sh 2>/dev/null",
        'r': 754,
        'p': 'gt',
    }, 
    'Task18': {
        'd': 'Permissions of logs/stdout.log',
        'vc': "stat -c %a /opt/enterprise-app/logs/stdout.log 2>/dev/null",
        'r': 544,
        'p': 'eq',
    }, 
    'Task19': {
        'd': 'Ownership of logs/stdout.log',
        'vc': "[[ $(stat -c %U /opt/enterprise-app/logs/stdout.log 2>/dev/null) != \"root\" ]] && echo 0 || echo 1",
        'r': 0,
        'p': 'eq',
    }, 
    'Task20': {
        'd': 'Permissions of logs/stderr.log',
        'vc': "stat -c %a /opt/enterprise-app/logs/stderr.log 2>/dev/null",
        'r': 544,
        'p': 'eq',
    }, 
    'Task21': {
        'd': 'Ownership of logs/stderr.log',
        'vc': "[[ $(stat -c %U /opt/enterprise-app/logs/stderr.log 2>/dev/null) != \"root\" ]] && echo 0 || echo 1",
        'r': 0,
        'p': 'eq',
    }, 
    'Task22': {
        'd': 'Permissions of file bin/app.py',
        'vc': "stat -c %a /opt/enterprise-app/bin/app.py 2>/dev/null",
        'r': 700,
        'p': 'eq',
    }, 
    'Task23': {
        'd': 'Symbolic link existence',
        'vc': "ls /opt/enterprise-app/code/alt_app_access >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task24': {
        'd': 'Correctness of symbolic link',
        'vc': "stat -c %N /opt/enterprise-app/code/alt_app_access >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    #-----------------------------------------------------------------------------------------
    'Task25': {
        'd': 'Existence of docs/report.out',
        'vc': "ls -l /opt/enterprise-app/docs/report.out >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task26': {
        'd': 'Recorded owner of bin/app.py',
        'vc': "grep -sE 'OWNER:*.*bin/app.py:root' /opt/enterprise-app/docs/report.out >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task27': {
        'd': 'Recorded owner of scripts/clean.sh',
        'vc': "grep -sE 'OWNER:*.*scripts/clean.sh:root' /opt/enterprise-app/docs/report.out >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task28': {
        'd': 'Recorded octal Permissions bin/app.py',
        'vc': "grep -sE 'PERMISSIONS:*.*bin/app.py:[[:digit:]]' /opt/enterprise-app/docs/report.out >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task29': {
        'd': 'Recorded octal Permissions scripts/clean.sh',
        'vc': "grep -sE 'PERMISSIONS:*.*scripts/clean.sh:[[:digit:]]' /opt/enterprise-app/docs/report.out >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task30': {
        'd': 'Recorded inode of bin/app.py',
        'vc': "grep -sE 'INODE:*.*bin/app.py:[[:digit:]]' /opt/enterprise-app/docs/report.out >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 
    'Task31': {
        'd': 'Recorded inode of scripts/clean.sh',
        'vc': "grep -sE 'INODE:*.*scripts/clean.sh:[[:digit:]]' /opt/enterprise-app/docs/report.out >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    }, 

}