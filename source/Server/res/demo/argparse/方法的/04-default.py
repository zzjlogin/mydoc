import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--length', default='10', type=int)
parser.add_argument('--width', default=10.5, type=int)
print(parser.parse_args())
#Namespace(length=10, width=10.5)