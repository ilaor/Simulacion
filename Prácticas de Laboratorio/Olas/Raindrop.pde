class Raindrop {
    PVector position;
    float speed;

    Raindrop() {
        // Generar coordenadas aleatorias dentro de los límites de la malla de las olas
        float startX = random(-_MAP_SIZE * _MAP_CELL_SIZE / 2f, _MAP_SIZE * _MAP_CELL_SIZE / 2f);
        float startY = -120; // Mantengo la misma posición inicial en y
        float startZ = random(-_MAP_SIZE * _MAP_CELL_SIZE / 2f, _MAP_SIZE * _MAP_CELL_SIZE / 2f);

        position = new PVector(startX, startY, startZ);
        speed = random(4, 6); // Reducimos la velocidad de caída
    }

    void update() {
        position.y += speed;
    }

    void display() {
        stroke(37, 40, 100);
        strokeWeight(10);
        line(position.x, position.y, position.z, position.x, position.y + 60, position.z); // Dibujar la línea en 3D
    }
}
