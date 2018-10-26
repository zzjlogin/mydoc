import sys 
import os 
import argparse
import logging

def parse_args(str):
    parser = argparse.ArgumentParser()
    parser.add_argument("-f","--force",action='store_true',help="force to do ")
    parser.add_argument("-r","--recursive",action='store_true', help="recursive sub dir ")
    parser.add_argument("src",help="you need to delete file or dir")
    args = parser.parse_args(str)
    return args

def check_and_create_trash_dir(trash_dir):
    if not os.path.exists(os.path.expanduser(trash_dir)):
        print("crate " + trash_dir + "start.")
        #os.makedirs(trash_dir)
        os.system("mkdir -p " + trash_dir)
        print("crate " + trash_dir + "finish.")
def exec_mv(args):
    cmd ="mv "
    if args.force:
        cmd +="-f "
    #if args.recursive:
    #   cmd +="-r "
    print(cmd) 
    os.system(cmd + args.src + " " + args.dst)

def main():
    trash_dir = "~/trash"
    print(sys.argv)
    print(sys.argv[1:])
    args=parse_args(sys.argv[1:])
    print(args)
    args.dst=trash_dir
    check_and_create_trash_dir(trash_dir)
    exec_mv(args)

if __name__ =="__main__":
    main()
