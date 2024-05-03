import argparse

def print_line(content):
    print(content.center(80,"#"))

# 测试默认值(store)
print_line("测试默认值(store)")
parser = argparse.ArgumentParser()
parser.add_argument('--foo')
print(parser.parse_args('--foo 1'.split()))
#Namespace(foo='1')

# 测试值(store_const)
print_line("测试值(store_const)")
parser2 = argparse.ArgumentParser()
parser2.add_argument('--foo', action='store_const', const=42)
print(parser2.parse_args(['--foo']))
#Namespace(foo=42)

# 测试值(store_true,store_false)
print_line("测试值(store_const)")
parser3 = argparse.ArgumentParser()
parser3.add_argument('--foo', action='store_true')
parser3.add_argument('--bar', action='store_false')
parser3.add_argument('--baz', action='store_false')
# 指定strore_true后，如果指定了这个选项后，那么结果就是true,没有指定就是false。
print(parser3.parse_args('--foo --bar'.split()))
#Namespace(bar=False, baz=True, foo=True)

# 测试值(append)
print_line("测试值(append)")
parser4 = argparse.ArgumentParser()
parser4.add_argument('--foo', action='append')
print(parser4.parse_args('--foo 1 --foo 2'.split()))
#Namespace(foo=['1', '2'])

# 测试值(append_const)
print_line("测试值(append_const)")
parser5 = argparse.ArgumentParser()
parser5.add_argument('--str', dest='types', action='append_const', const=str)
parser5.add_argument('--int', dest='types', action='append_const', const=int)
print(parser5.parse_args('--str --int'.split()))
#Namespace(types=[<class 'str'>, <class 'int'>])

# 测试值(count)
print_line("测试值(count)")
parser6 = argparse.ArgumentParser()
parser6.add_argument('--verbose', '-v', action='count')
print(parser6.parse_args(['-vvv']))
#Namespace(verbose=3)


# 测试值(version)
print_line("测试值(version)")
import argparse
parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('--version', action='version', version='%(prog)s 2.0')
print(parser.parse_args(['--version']))
#PROG 2.0




