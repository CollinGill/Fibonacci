SRC = main.asm
OBJ = main.o
TARGET = fibonacci 

$(TARGET) : $(OBJ)
	ld $(OBJ) -o $(TARGET)

$(OBJ) : $(SRC)
	nasm -felf64 $(SRC)

clean:
	rm *.o $(TARGET)