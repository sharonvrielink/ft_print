# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: svrielin <svrielin@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2021/11/23 13:15:55 by svrielin      #+#    #+#                  #
#    Updated: 2021/11/24 17:13:41 by svrielin      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME			:=	libftprintf.a
CC				:=	gcc
CFLAGS			?=	-Wall -Wextra -Werror

#################################Project_files##################################
SRC_DIR			:=	./src
SRC_FILES		:=	ft_printf.c
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
# gcc -o: name of the output file
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# -C dir: change to the directory dir before reading the makefiles
$(LIB):
	$(MAKE) -C ./libft

clean:
	rm -f $(OBJ_FILES) 
	rmdir $(OBJ_DIR)
	$(MAKE) clean -C ./libft
	@echo "Object files and directory removed"

# Clean should be a prerequisite of fclean, but that way I can never remove the .a file after using clean
# LET OP!!!! Changed this also for the libft makefile, in this submodule
fclean:
	@rm -f $(NAME)
	$(MAKE) fclean -C ./libft
	@echo "Library printf removed"

re: fclean all

.PHONY: clean fclean
