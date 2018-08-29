import argparse

parser =  argparse.ArgumentParser(
    prog="test",
    description="测试formatter_class",
    epilog="这里是epilog信息",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )

parser.add_argument('--foo', type=int, default=42, help='FOO!')
parser.add_argument('bar', nargs='*', default=[1, 2, 3], help='BAR!')

print("\n默认(argparse.ArgumentDefaultsHelpFormatter)的格式化输出\n")
parser.print_help()

parser.formatter_class=argparse.RawDescriptionHelpFormatter
print("\n(argparse.RawDescriptionHelpFormatter¶)的格式化输出\n")
parser.print_help()

parser.formatter_class=argparse.RawTextHelpFormatter
print("\n(argparse.RawTextHelpFormatter)的格式化输出\n")
parser.print_help()


