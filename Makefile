# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: svrielin <svrielin@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2021/11/23 13:15:55 by svrielin      #+#    #+#                  #
#    Updated: 2022/05/21 10:23:53 by svrielin      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

# := simple variable assignment, it gets evaluated when first encountered/defined
# Everytime afterwards when you use the variable it will be replaced
# = recursive variable use. Everytime the variable is used it will be evaluated (NOT when defined)

NAME			:=	libftprintf.a
#CC				:=	gcc
CFLAGS			:=	-Wall -Wextra -Werror

#################################Project_files##################################
SRC_DIR			:=	./src
SRC_FILES		:=	ft_printf.c printchar.c printstring.c printnumber.c printunsignednumber.c \
					printhex.c printhex_upper.c printpointer.c
OBJ_DIR			:=	./obj
OBJ_FILES		:=	$(addprefix $(OBJ_DIR)/, $(SRC_FILES:.c=.o))
LIB				:=	./libft/libft.a

all: $(NAME)

# $@ filename of the target $^ all prerequisites
# r: uses replacement for the objects files while inserting the files member into archive
# c: create the library if it does not exist
# ar -q: quickly append the .o files of ft_printf to the archive libft.a
# cp: copies libft.a to libftprintf.a
$(NAME): $(OBJ_FILES) $(LIB)
	ar rc $@ $^
	ar -q $(LIB) $(OBJ_FILES)
	cp $(LIB) $(NAME)

# -p: if parent dirs do not exist, generate them to accommodate 
# gcc -c: compile but not link the file, makes the result an object file
# $< is the first prerequisite
# gcc -o: name of the output file
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# -C dir: change to the directory dir before reading the makefiles
$(LIB):
	$(MAKE) -C ./libft

# rm -df instead of rmdir, because this doesn't give an error when dir doesn't exist
# -d: dir, removes empty directories
# -f: force, ignore nonexistant files
clean:
	rm -f $(OBJ_FILES) 
	rm -df $(OBJ_DIR)
	$(MAKE) clean -C ./libft
	@echo "Object files and directory removed"

fclean: clean
	@rm -f $(NAME)
	$(MAKE) fclean -C ./libft
	@echo "Library printf removed"

# The -L flag indicates (a non standard) directory where the libraries can be found.
# The -l flag indicates the name of the library. 
# Note, that it assumes the library to start with lib and end with .a (so lib and .a must not be specified)
main: all
	$(CC) $(CFLAGS) -fsanitize=address -g main.c -lftprintf -L. -o ft_printf

re: fclean all

.PHONY: clean fclean main
