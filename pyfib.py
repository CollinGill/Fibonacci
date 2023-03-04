import sys

def fibonacci(n):
    memo = {1: 1, 2: 1}

    def help(num):
        if num in memo:
            return memo[num]
        memo[num] = help(num - 1) + help(num - 2)
        return memo[num]

    return help(n)


if __name__ == '__main__':
    num = int(sys.argv[1])
    print(fibonacci(num))