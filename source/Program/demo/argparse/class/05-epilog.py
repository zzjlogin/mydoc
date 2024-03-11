import argparse 

parser = argparse.ArgumentParser(description=u"测试下epilog",epilog=u"这个已经过期了，建议改用ip命令")

parser.print_help()