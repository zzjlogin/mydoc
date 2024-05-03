import argparse

parser = argparse.ArgumentParser(prog='PROG', conflict_handler='resolve')
parser.add_argument('-f', '--foo', help='old foo help')
parser.add_argument('--foo', help='new foo help')

print("解决冲突的方式结果")
parser.print_help()

print("默认的结果")
parser2 = argparse.ArgumentParser(prog='PROG')
parser2.add_argument('-f', '--foo', help='old foo help')
parser2.add_argument('--foo', help='new foo help')