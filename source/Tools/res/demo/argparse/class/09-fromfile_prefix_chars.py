import argparse

with open('args.txt', 'w') as fp:
    fp.write('-f\nbar')

parser = argparse.ArgumentParser(fromfile_prefix_chars='@')
parser.add_argument('-f')

print(parser.parse_args(['-f', 'foo']))
print(parser.parse_args(['-f', 'foo', '@args.txt']))