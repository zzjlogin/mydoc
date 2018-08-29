import argparse

parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('-x', nargs=2)
parser.add_argument('--foo', nargs=4, metavar=('east', 'west','south','north'))
print(parser.print_help())
