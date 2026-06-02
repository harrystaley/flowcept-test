"""
A minimal example of Flowcept's instrumentation using @decorators.
This example needs no DB, broker, or external service.
"""
import json

from flowcept import Flowcept, flowcept_task
from flowcept.instrumentation.flowcept_decorator import flowcept


@flowcept_task(output_names="o1")
def sum_one(i1):
    return i1 + 1


@flowcept_task(output_names="o2")
def mult_two(o1):
    return o1 * 2


@flowcept
def main():
    n = 3
    o1 = sum_one(n)
    o2 = mult_two(o1)
    print("Final output", o2)


if __name__ == "__main__":
    main()

    prov_messages = Flowcept.read_buffer_file()
    assert len(prov_messages) == 2
    print(json.dumps(prov_messages, indent=2))