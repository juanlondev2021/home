public class DiacoRecordTypeWebFormAppointmentDTO {
    @AuraEnabled
    public ID Id;
    @AuraEnabled
    public String Name;
    @AuraEnabled
    public String Interest;

    public DiacoRecordTypeWebFormAppointmentDTO() {

    }

    public DiacoRecordTypeWebFormAppointmentDTO(ID Id, string Name,String Interest) {

        this.Id = Id;
        this.Name = Name;
        this.Interest = Interest;
    }

    public static Map<String,DiacoRecordTypeWebFormAppointmentDTO> getRecordTypeRelateTo() {

        Map<String,DiacoRecordTypeWebFormAppointmentDTO> relate = new Map<String,DiacoRecordTypeWebFormAppointmentDTO>();
        relate.put('Smart Home Automation', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jgQAA','Home Automation','Smart Home Automation'));
        relate.put('Windows', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jxQAA','Windows','Windows') );
        relate.put('House Cleaning',new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jhQAA','House Cleaning','House Cleaning'));
        relate.put('Bath', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3qfQAA','Bathroom Remodel','Bath'));
        relate.put('Kitchen', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3qgQAA','Kitchen Remodel','Kitchen'));
        relate.put('TV & Internet', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jvQAA','TV & Internet','TV & Internet'));
        relate.put('Pest Control', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jmQAA','Pest Control','Pest Control'));
        relate.put('Water Filtration', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jwQAA','Water Filtration','Water Filtration'));
        relate.put('Blinds & Shutters',  new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jVQAQ','Blinds & Shutters','Blinds & Shutters'));
        relate.put('HVAC',   new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jeQAA','HVAC','HVAC'));
        relate.put('Painting', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jlQAA','Painting','Painting'));
        relate.put('Floor Cleaning', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jWQAQ','Carpet/Floor Cleaning','Floor Cleaning'));
        relate.put('Solar', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jtQAA','Solar','Solar'));
        relate.put('Plumbing', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jnQAA','Plumbing','Plumbing'));
        relate.put('Garage Floor Coating', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jZQAQ','Concrete Coating','Garage Floor Coating'));
        relate.put('Garage Organization',  new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jdQAA','Garage Organization','Garage Organization'));
        relate.put('Flooring', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jbQAA','Flooring','Flooring'));
        relate.put('Electric',  new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jaQAA','Electrical','Electric'));
        relate.put('Roofing',  new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jrQAA','Roofing','Roofing'));
        relate.put('Locksmith',  new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jkQAA','Locksmith','Locksmith'));
        relate.put('Handyman',new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jfQAA','Handyman','Handyman'));
        relate.put('Addition(s)', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jUQAQ','Addition(s)','Addition(s)'));
        relate.put('Security Doors', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jsQAA','Security Doors','Security Doors'));
        relate.put('Sunroom Patio Enclosure', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3juQAA','Sunroom Patio Enclosure','Sunroom Patio Enclosure'));
        relate.put('Closet Organization',  new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jXQAQ','Closet Organization','Closet Organization'));
        relate.put('Concrete', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jYQAQ','Concrete','Concrete'));
        relate.put('Garage Doors', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jcQAA','Garage Doors','Garage Doors'));
        relate.put('Pool Design/Installation', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3joQAA','Pool Design/Installation','Pool Design/Installation'));
        relate.put('Pool Maintenance',  new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jpQAA','Pool Maintenance','Pool Maintenance'));
        relate.put('Landscape Design/Installation', new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jiQAA','Landscape Design/Installation','Landscape Design/Installation'));
        relate.put('Landscape Maintenance',new DiacoRecordTypeWebFormAppointmentDTO('0121K000001h3jjQAA','Landscape Maintenance','Landscape Maintenance'));

        return relate;
    }
}