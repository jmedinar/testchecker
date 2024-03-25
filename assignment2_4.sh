
mod2_4 = {
    'Task1': {
        'd': 'Verifying user: CHIN YEN',
        'vc': "id cyen 2>/dev/null | grep -E 'accounting' >/dev/null 2>&1 && grep cyen@wedbit.com /etc/passwd >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task2': {
        'd': 'Verifying user: MIKE PEARL',
        'vc': "id mpearl 2>/dev/null | grep -E 'accounting' >/dev/null 2>&1 && grep mpearl@wedbit.com /etc/passwd >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task3': {
        'd': 'Verifying user: JOHN GREEN',
        'vc': "id jgreen 2>/dev/null | grep -E 'accounting|technology|directionboard|humanresources' >/dev/null 2>&1 && grep jgreen@wedbit.com /etc/passwd >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task4': {
        'd': 'Verifying user: DEWAYNE PAUL',
        'vc': "id dpaul 2>/dev/null | grep -E 'technology' >/dev/null 2>&1 && grep dpaul@wedbit.com /etc/passwd >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task5': {
        'd': 'Verifying user: MATTS SMITH',
        'vc': "id msmith 2>/dev/null | grep -E 'technology' >/dev/null 2>&1 && grep msmith@wedbit.com /etc/passwd >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task6': {
        'd': 'Verifying user: PLANK OTO',
        'vc': "id poto 2>/dev/null | grep -E 'technology' >/dev/null 2>&1 && grep poto@wedbit.com /etc/passwd >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task7': {
        'd': 'Verifying user: MOHAMMED KHAN',
        'vc': "id mkhan 2>/dev/null | grep -E 'technology' >/dev/null 2>&1 && grep mkhan@wedbit.com /etc/passwd >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task8': {
        'd': 'Verifying user: LAURA LOPEZ',
        'vc': "id llopez 2>/dev/null | grep -E 'accounting|technology|directionboard|humanresources' >/dev/null 2>&1 && grep llopez@wedbit.com /etc/passwd >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
    'Task9': {
        'd': 'Verifying user: JOSE ANGEL RAMIREZ',
        'vc': "id jramirez 2>/dev/null | grep -E 'technology|accounting' >/dev/null 2>&1 && grep jramirez@wedbit.com /etc/passwd >/dev/null 2>&1; echo $?",
        'r': 0,
        'p': 'eq',
    },
}