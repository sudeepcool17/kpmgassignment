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

