import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--foo', dest='bar')
print(parser.parse_args('--foo XXX'.split()))
#Namespace(bar='XXX')
parser2 = argparse.ArgumentParser()
parser2.add_argument('--foo')
print(parser2.parse_args('--foo XXX'.split()))
#Namespace(foo='XXX')