from src.cieshw_pdf import templating

ret = templating.pdf()
print(f"templating returned: {ret}")

'''
\begin{figure}[H]
    \begin{center}
        \input{measured.pgf}
        \caption{Gemessene Werte und Regressionsfunktion einer Fahrt aus 1 m Entfernung zum Ziel.}
        \label{fig:mea}
    \end{center}
\end{figure}
'''