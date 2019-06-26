#*******************************************************************************
 #
 #  Filename    : prompt.py
 #  Description : Simple function for prompting user for python scripts
 #  Author      : Yi-Mu "Enoch" Chen [ ensc@hep1.phys.ntu.edu.tw ]
 #
#*******************************************************************************
import sys

def prompt(question, default="no"):
    """
    Ask a yes/no question via raw_input() and return their answer.

    - "question" is a string that is presented to the user.
    - "default" is the presumed answer if the user just hits <Enter>. It must be
      "yes" (the default), "no" or None (meaning an answer is required of the
      user).

    The "answer" return value is True for "yes" or False for "no".
    """
    valid = {"yes": True, "ye": True, "y": True,
             "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default.lower() == "yes":
        prompt = " [Y/n] "
    elif default.lower() == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' "
                             "(or 'y' or 'n').\n")
