from flask import Flask
import random

app = Flask(__name__)

@app.route('/')
def hello_world():
    number = random.randint(1, 1000000)
    return f'Hello, World! {number}'

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
