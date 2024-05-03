import argparse

parent_parser= argparse.ArgumentParser(add_help=False)
parent_parser.add_argument('--count',type=int )

child1_parser= argparse.ArgumentParser(parents=[parent_parser])

child1_parser.add_argument("--test1")

child2_parser= argparse.ArgumentParser(parents=[parent_parser])

child2_parser.add_argument("--test2")

print("parent的使用帮助\n")
parent_parser.print_help()

print("child1的使用帮助\n")
child1_parser.print_help()

print("child2的使用帮助\n")
child2_parser.print_help()