//
// THIS IS AN AUTO-GENERATED FILE. DO NOT MODIFY IT DIRECTLY.
// MODIFY THE TEMPLATE IN THE IPHONE PROJECT INSTEAD.
//

import java.util.*;

public abstract class GeneratedDatabase
{
    public static class Igreja
    {
        public static abstract class Event
        {
            enum Type {
                Confissao,
                Missa
            }

            public Integer endTime = null;
            public String observation = null;
            public Integer startTime = null;
            public Type type = null;

            public Igreja igreja = null;
        }

        public static class WeeklyEvent extends Event
        {
            public Integer weekday = null;
        }

        public static class MonthlyEvent extends Event
        {
            public Integer day = null;
            public Integer week = null;
        }

        public static class YearlyEvent extends Event
        {
            public Integer day = null;
            public Integer month = null;
        }

        public String bairro = null;
        public String cep = null;
        public String email = null;
        public String endereco = null;
        public Date lastModified = null;
        public Double latitude = null;
        public Double longitude = null;
        public String nome = null;
        public String normalizedBairro = null;
        public String normalizedNome = null;
        public String observacao = null;
        public String paroco = null;
        public String site = null;
        public String telefones = null;

        public ArrayList<Event> events = new ArrayList<Event>();
    }

    protected ArrayList<Igreja> mAllIgrejas = new ArrayList<Igreja>();
    protected ArrayList<Igreja.Event> mAllEvents = new ArrayList<Igreja.Event>();

%%DATA%%}
