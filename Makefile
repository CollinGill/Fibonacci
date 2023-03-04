OBJ = main.o util.o
TARGET = fibonacci 

$(TARGET) : $(OBJ)
	ld $(OBJ) -o $(TARGET)

%.o : %.asm
	nasm -felf64 $< -o $@

clean:
	rm *.o $(TARGET)