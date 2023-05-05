from flask import Flask, request, jsonify
import json

app = Flask(__name__)

def read_numbers_from_file(filename):
    with open(filename, 'r') as file:
        return {line.strip() for line in file}

def write_numbers_to_file(filename, numbers):
    with open(filename, 'w') as file:
        for number in numbers:
            file.write(number + "\n")

@app.route('/dl', methods=['POST'])
def dl():
    data = request.get_json()
    if data is None:
        return 'Erreur: pas de données JSON reçues', 400

    numbers_received = set(data)
    numbers_bdd = read_numbers_from_file('bdd.txt')

    new_numbers = numbers_received - numbers_bdd
    if new_numbers:
        numbers_bdd |= new_numbers
        write_numbers_to_file('bdd.txt', numbers_bdd)
        write_numbers_to_file('new.txt', new_numbers)

    return 'OK', 200

@app.route('/new', methods=['GET'])
def new():
    numbers_new = read_numbers_from_file('new.txt')
    return jsonify([str(number) for number in numbers_new])

if __name__ == '__main__':
    app.run(debug=True)
