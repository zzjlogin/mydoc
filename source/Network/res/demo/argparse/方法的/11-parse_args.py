import argparse

parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('-x')
parser.add_argument('--foo')
print(parser.parse_args(['-x', 'X']))
#Namespace(foo=None, x='X')
print(parser.parse_args(['--foo', 'FOO']))
#Namespace(foo='FOO', x=None)

print(parser.parse_args(['--foo=FOO']))
#Namespace(foo='FOO', x=None)

parser2 = argparse.ArgumentParser(prog='PROG')
parser2.add_argument('-x', action='store_true')
parser2.add_argument('-y', action='store_true')
parser2.add_argument('-z')
print(parser2.parse_args(['-xyzZ']))
#Namespace(x=True, y=True, z='Z')


parser3 = argparse.ArgumentParser()
parser3.add_argument('--foo')
args = parser3.parse_args(['--foo', 'BAR'])
print(vars(args))
#{'foo': 'BAR'}


class C:
    pass

c = C()
parser4 = argparse.ArgumentParser()
parser4.add_argument('--foo')
parser4.parse_args(args=['--foo', 'BAR'], namespace=c)
#print(c.foo)
#'BAR'

