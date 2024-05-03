import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--foo', help='foo help')
print("\n有帮助的输出结果\n")
parser.print_help()

parser2 = argparse.ArgumentParser(add_help=False)
parser2.add_argument('--foo', help='foo help')
print("\n没有帮助的输出结果\n")
parser2.print_help()

