
mod2_5 = {
    'Task1': {
        'd': 'Verifying processFile.sh',
        'vc': "/sysadm/bin/processFile.sh /etc/passwd 2>&1 | grep method | wc -l",
        'r': 0,
        'p': 'gt',
    },
    'Task2': {
        'd': 'Verifying rabbitJumps.sh',
        'vc': "/sysadm/bin/rabbitJumps.sh 2>&1 | grep SUCCESS >/dev/null; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task3': {
        'd': 'Verifying testString.sh',
        'vc': "/sysadm/bin/testString.sh 1 2>/dev/null",
        'r': "Binary or positive integer",
        'p': 'get',
    },
    'Task4': {
        'd': 'Verifying color.sh',
        'vc': "/sysadm/bin/color.sh >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
}
# mod2_6 doesn't have checker database