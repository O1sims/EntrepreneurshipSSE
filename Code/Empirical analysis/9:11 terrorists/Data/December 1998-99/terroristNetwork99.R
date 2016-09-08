nodeNames <- c("Ahmed Al Haznawi",
               "Ahmed Alghamdi",
               "Ahmed Alnami",
               "Bandar Alhazmi",
               "Hamza Alghamdi",
               "Hani Hanjour",
               "Khalid Al-Mihdhar",
               "Mamoun Darkazanli",
               "Marwan Al-Shehhi",
               "Mohamed Atta",
               "Mounir El Motassadeq",
               "Mustafa Al-Hisawi",
               "Nabil Al-Marabh",
               "Nawaf Alhazmi",
               "Raed Hijazi",
               "Ramzi Bin Al-Shibh",
               "Rayed Abdullah",
               "Saeed Alghamdi",
               "Said Bahaji",
               "Salem Alhazmi",
               "Wail Alshehri",
               "Waleed Alshehri",
               "Zacarias Moussaoui",
               "Zakariya Essabar",
               "Ziad Jarrah",
               "Khalid Sheikh Mohammed",
               "Mohammed Haydar Zammar")

sources <- c(1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 4, 5, 5, 5, 5, 6, 6, 7, 7, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 14, 14, 14, 14, 14, 15, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 20, 20, 21, 22, 22, 22, 22, 22, 23, 24, 24, 24, 24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 25, 25, 25, 26, 26, 26, 26, 27, 27, 27, 27, 27, 27, 27)
targets <- c(2, 18, 5, 3, 22, 5, 14, 1, 18, 2, 18, 6, 17, 14, 1, 18, 2, 4, 17, 20, 14, 27, 9, 11, 19, 10, 25, 24, 27, 8, 25, 10, 19, 16, 24, 11, 25, 22, 8, 9, 27, 19, 11, 24, 16, 26, 27, 9, 8, 25, 16, 24, 10, 19, 23, 15, 7, 20, 5, 2, 18, 26, 13, 24, 11, 9, 19, 22, 25, 10, 26, 4, 6, 14, 1, 5, 3, 2, 9, 8, 22, 26, 10, 16, 24, 11, 27, 25, 7, 14, 22, 21, 2, 10, 16, 19, 12, 27, 11, 9, 8, 19, 25, 10, 16, 8, 9, 27, 11, 19, 24, 16, 10, 19, 10, 16, 14, 8, 9, 25, 10, 19, 11, 24)

N <- data.frame(number = seq(from = 1,
                             to = length(nodeNames),
                             by = 1),
                nodes = nodeNames)

network <- data.frame(sources = sources,
                      targets = targets)

network <- unique(network[,])
