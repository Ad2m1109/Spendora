from app import app

@app.route('/generate-graph', methods=['POST'])
def generate_graph():
    # ...existing code...
    return "Graph generated"
