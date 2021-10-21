Challenge 3
===========

We have a nested object, we would like a function that you pass in the object and a key and get back the value. How this is implemented is up to you.
Example Inputs
object = {“a”:{“b”:{“c”:”d”}}}
key = a/b/c
object = {“x”:{“y”:{“z”:”a”}}}
key = x/y/z
value = a
Hints:
We would like to see some tests. A quick read to help you along the way
We would expect it in any other language apart from elixir.
A quick read to help you along the way 
 
Once this has been completed please send us the output so we can get the ball rolling.

Solution:
=========
1.open pycharm or any other ISE and create a new project
2. Write below command and compile the same to get the desired output

def parse_object(object_val, key):
    # Strip the key of start and railing
    # Split the key based on
    keys = key.strip('/').split('/')
    # print(keys)
    for key in keys:
        if key in object_val:
            object_val = object_val[key]
        else:
            print ("Key not found")
            exit(1)
    return object_val

object_def = {"a":{"b":{"c": "d"}}}
print(parse_object(object_def,'a/b/c'))

object_def = {"x":{"y":{"z": "a"}}}
print(parse_object(object_def,'x/y/z'))
========================================================
Output:
https://user-images.githubusercontent.com/68887254/138213290-0f9e026d-3453-4291-9e6f-e1f661e7a034.png
