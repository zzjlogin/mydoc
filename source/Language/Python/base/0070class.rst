.. _python_class:

======================================================================================================================================================
对象编程
======================================================================================================================================================

.. contents::


类的基本操作
======================================================================================================================================================

类和对象创建
------------------------------------------------------------------------------------------------------------------------------------------------------

创建类以及对象的基本样例：

.. code-block:: python
    :linenos:

    class Car(object):
        type='car'

        def __init__(self, name, colour):
            self.name = name
            self.colour = colour
            print('我被创建了。')

    c1=Car('Lamborghini','yellow')
    print(c1.type)
    print(Car.type)
    print('name:%s,colour:%s'%(c1.name,c1.colour))

运行后输出结果：

.. code-block:: text
    :linenos:

    我被创建了。
    car
    car
    name:Lamborghini,colour:yellow

------




类的继承
======================================================================================================================================================


新式类和经典类
------------------------------------------------------------------------------------------------------------------------------------------------------

在python中的类一般是两种：新式类、经典类。

现在一般常用的创建类的方式，都会继承 ``object`` 这个基类，这种类叫做新式类。

如果没有继承 ``object`` 则是经典类。

经典类和新式类的区别：
    - 经典类的继承关系是深度优先的。
    - 新式类的继承关系是广度优先的。
    - Python3.X所有的都是新式类，取消了新式类和经典类这种方法了。

在新式类中：
    程序员定义的每一个类，python会计算出一个方法解析顺序(MRO)列表，
    这个MRO列表就是一个简单的所有基类的线性顺序列表
    为了实现继承，python会在MRO列表上从左到右开始查找基类，当到找到第一个匹配这个属生的类为止，
    而这个MRO列表的构造是通过一个C3线性化算法来实现的。
    它实际上就是合并所有父类的MRO列表并遵循如下三条准则:
        1. 子类会先于父类被检查【类似作用域】
        2. 多个父类会根据它们在列表中的顺序被检查
        3. 如果对下一个类存在两个合法的选择，选择第一个父类


相关参考：
    - https://www.python.org/doc/newstyle/
    - https://docs.python.org/release/2.2.3/whatsnew/sect-rellinks.html


继承重载
------------------------------------------------------------------------------------------------------------------------------------------------------

例如类Bus继承了Car这个类，Bus类重载Car类的tools方法。

.. code-block:: python
    :linenos:

    class Car(object):

        def __init__(self, name):
            self.name = name
        def getname(self):
            return self.name
        def tools(self):
            return 'car'

    class Bus(Car,object):

        def __init__(self, name):
            self.name = name
        # 重载tools
        def tools(self):
            return 'Bus'

    A = Bus('gongjiao')
    A.getname()
    # 输出
    gongjiao
    A.tools()
    Bus


类的不同方法
======================================================================================================================================================

类中的方法一般有：实例方法、类方法、静态方法、接口实现、抽象类、super使用



实例方法
------------------------------------------------------------------------------------------------------------------------------------------------------

实例方法：
    就是我们通常常用在类中定义的方法。
    可以通过类的对象调用这个方法，这个方法如果在python3中通过类调用会TypeError错误。

下面是python类中实例的方法的定义及使用：

.. code-block:: python
    :linenos:

    class Car(object):

        def __init__(self, name):
            self.name = name
        #函数名为getname的普通方法
        def getname(self):
            return self.name
        #函数名为tools的普通方法
        def tools(self):
            return 'car'

实例化对象然后调用查看输出：

.. code-block:: python
    :linenos:

    a = Car('A6')
    #对象调用tools方法
    a.tools()

    #下面是输出内容
    #'car'



类方法
------------------------------------------------------------------------------------------------------------------------------------------------------

类方法：
    - 使用装饰器 ``@classmethod`` 。
    - 第一个参数必须是当前类对象，该参数名一般约定为“cls”，
      通过它来传递类的属性和方法（不能传实例的属性和方法）；
    - 调用：实例对象和类对象都可以调用。

可以发现类方法的一些特征：
    - 类方法可以使用类的属性，但是操作类属性以后就会全局改变类属性。
      所以可以使用私有属性或者保护属性(用 ``__`` 开始的变量名称为私有属性，
      用 ``_`` 开始的变量名称为保护属性)

下面测试样例：

.. code-block:: python
    :linenos:

    class ClassTest(object):
        
        #类的属性num
        num = 0

        @classmethod
        def addNum(cls):
            cls.num += 1
            return cls.num

实例化上面类，然后测试类函数：

.. code-block:: python
    :linenos:

    test = ClassTest()
    test.addNum()
    #下面是输出结果
    1

查看此时的类的num的属性值：

.. code-block:: text
    :linenos:

    ClassTest.num
    1

静态方法
------------------------------------------------------------------------------------------------------------------------------------------------------

静态方法：
    - 使用装饰器 ``@staticmethod`` 。
    - 不用传入实例方法参数 ``self`` 和类方法的参数 ``cls`` 
    - 静态方法体中并不能使用类或实例的属性（或方法）
    - 对于静态方法而言，所在类更像是一种名称空间
    - 如果没有传入参数 ``self`` 和 ``cls``，即使没有装饰器 ``@staticmethod``，也可以看作静态方法。
    - 调用：实例对象和类对象都可以调用。

    类似于外部定义的函数，可以通过类名称直接调用这个静态方法。

.. code-block:: python
    :linenos:

    class Car(object):
        name = 'car'
        def __init__(self, name):
            self.name = name
        @staticmethod
        def getname():
            print('ok')
    Car.getname()
    #下面是输出内容
    ok


接口实现
------------------------------------------------------------------------------------------------------------------------------------------------------

接口是一组功能的入口，要调用某一组功能，需要通过接口来进行调用，
而不需要关注这组功能是如何实现的，要的只是结果。

在类里，接口是提取了一群类共同的函数，可以把接口当做一个函数的集合。

接口父类只是定义有什么方法，但是并不具体实现其方法体，
当有子类去继承该父类时候，需要具体去实现这些方法体。

.. code-block:: python
    :linenos:

    class Animal():
        def eat(self):
            pass
        def read(self):
            pass

    class Cat(Animal):
        def eat(self,name):
            print('%s 在吃鱼' %name)

        def read(self,name):
        print('%s 在读书' %name)
    a=Animal()
    print(a.eat())
    c=Cat()
    c.eat("周周")

    # 下面是输出内容
    #None
    #周周 在吃鱼

抽象类
------------------------------------------------------------------------------------------------------------------------------------------------------

抽象类：通过abc模块实现抽象类，可以理解为对接口的封装，用于实现接口的归一化。

当子类继承抽象类的时候，如果抽象类定义了抽象方法，那么子类必须要定义同名的方法。即父类限制：
    1. 子类必须要有父类的方法
    2. 子类实现的方法必须跟父类的方法的名字一样


.. code-block:: python
    :linenos:

    import abc
    class Animal(metaclass=abc.ABCMeta):
        @abc.abstractmethod
        def eat(self):
            pass
        @abc.abstractmethod
        def read(self):
            pass

    class Cat(Animal):
        def eat(self,name):
            print('%s 在吃鱼' %name)

        def read(self,name):
        print('%s 在读书' %name)

    ###a=Animal()
    #####注意注意，不能实例化，否则报错
    #####TypeError: Can't instantiate abstract class Animal with abstract methods eat, read
    c=Cat()
    c.eat("周周")
    # 下面是输出内容
    #周周 在吃鱼


super使用(重载)
------------------------------------------------------------------------------------------------------------------------------------------------------

类中方法重载一般可以通过的方式：
    - 子类对父类的同名方法完全重载，此时不用super，也不用父类名称调用父类的对应方法，直接重写对应方法功能即可。
    - 子类的方法是对父类同名方法功能的扩展，所以可以在父类功能基础上增加这个功能即可，此时的重载方法可以使用super或者父类名称。

super（）会严格按照mro列表从当前查找到的位置继续往后查找

在子类中不会自动调用父类的 ``__init__()`` ,所以也可以使用super来简化代码

在子类中调用父类的方法或属性，可以使用super方法或者父类的名称加方法/属性值的方式。

使用super方法实例：
    - 一般在python2中，需要super(自己的类名,self)
    - python3中，括号里面一般不填类名

.. code-block:: python
    :linenos:

    class People(object):
        def __init__(self, gender, name):
            self.gender = gender
            self.name = name
        def getinfo(self):
            return [self.gender, self.name]
    class Student(People):
        def __init__(self, gender, name, grade, school):
            super().__init__(gender,name)
            self.grade = grade
            self.school = school
        def getinfo(self):
            #return在python3中如果重载需要全部重写，如果用super/父类明方式重载会失败。
            return [self.gender, self.name, self.grade, self.school]

    #test = People('fmale','xiaohong')
    #test.getinfo()

    test2 = Student('fmale','xiaohong','3', 'xiaoxue')
    test2.getinfo()
    #以下是输出内容：
    #['fmale', 'xiaohong', '3', 'xiaoxue']


    