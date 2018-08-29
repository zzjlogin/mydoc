import argparse

parser = argparse.ArgumentParser(prog="mytest2")

parser.add_argument('--src',help='%(prog) 的源地址')
parser.add_argument('-t' ,help="指定类型")
parser.print_usage()
print("="*40)