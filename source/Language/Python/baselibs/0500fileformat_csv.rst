.. _python_csv:

======================================================================================================================================================
:mod:`csv` --- 文件格式
======================================================================================================================================================

.. contents::

csv实例
======================================================================================================================================================


CSV：Comma Separated Values，逗号分割的文件，使用比较广泛。



csv.writer(csvfile, dialect='excel', \*\*fmtparams)
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: python
    :linenos:

    In [59]: import csv

    In [60]: with open("eggs.csv",'w',newline='') as f:
        ...:     fw=csv.writer(f,delimiter=' ',quotechar='!',quoting=csv.QUOTE_MINIMAL)
        ...:     fw.writerow([1,2,3,4])
        ...:     fw.writerow([2,3,4,5])
        ...:

csv.reader(csvfile, dialect='excel', \*\*fmtparams)
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: python
    :linenos:

    In [61]: import csv

    In [62]: with open('eggs.csv',newline='') as f:
        ...:     fr=csv.reader(f,delimiter=' ',quotechar='|')
        ...:     for row in fr:
        ...:         print(','.join(row))
        ...:
    1,2,3,4
    2,3,4,5

csv.DictWriter(f, fieldnames, restval='', extrasaction='raise', dialect='excel', \*args, \*\*kwds)
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: python
    :linenos:

    In [63]: import csv
        ...:
        ...: with open('names.csv', 'w', newline='') as csvfile:
        ...:     fieldnames = ['first_name', 'last_name']
        ...:     writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        ...:
        ...:     writer.writeheader()
        ...:     writer.writerow({'first_name': 'Baked', 'last_name': 'Beans'})
        ...:     writer.writerow({'first_name': 'Lovely', 'last_name': 'Spam'})
        ...:     writer.writerow({'first_name': 'Wonderful', 'last_name': 'Spam'})

csv.reader(csvfile, dialect='excel', \*\*fmtparams)
------------------------------------------------------------------------------------------------------------------------------------------------------

.. code-block:: python
    :linenos:

    In [64]: import csv

    In [65]: with open('names.csv', newline='') as csvfile:
        ...:     reader = csv.DictReader(csvfile)
        ...:     for row in reader:
        ...:         print(row['first_name'], row['last_name'])
        ...:
    Baked Beans
    Lovely Spam
    Wonderful Spam

csv详解
======================================================================================================================================================

