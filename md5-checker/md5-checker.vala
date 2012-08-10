
public class MD5Checker : Granite.Application {

    construct {
        program_name = "MD5 Checker";
        exec_name = "md5-checker";
        
        app_years = "2012";
        app_icon = "md5-checker";
        app_launcher = "md5-checker.desktop";
        
        about_authors = {"Chris Triantafillis <christriant1995@gmail.com>"};
        about_documenters = {"Chris Triantafillis <christriant1995@gmail.com>"};
        about_comments = "";
        about_translators = "";
        about_license_type = Gtk.License.GPL_3_0;
        
    }
    
    Gtk.Entry md5_entry;
    Gtk.Label result_label;
    Gtk.FileChooserButton iso_file_chooser;
    
    string md5;
    string file_md5;
    
    public MD5Checker () {
    
        var w = new Granite.Widgets.LightWindow ();
        var md5_label = new Gtk.Label ("Checksum:");
        var iso_label = new Gtk.Label ("File:");
        result_label = new Gtk.Label ("");
        md5_entry = new Gtk.Entry ();
        md5_entry.set_hexpand(true);
        iso_file_chooser = new Gtk.FileChooserButton ("Select a file",  Gtk.FileChooserAction.OPEN);
        
        var grid = new Gtk.Grid ();
        grid.set_column_spacing (5);    
        grid.set_row_spacing (5);
        
        var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
           
        grid.attach (md5_label, 0, 0, 1, 1);
        grid.attach (iso_label, 0, 1, 1, 1);
        grid.attach (md5_entry, 1, 0, 1, 1);
        grid.attach (iso_file_chooser, 1, 1, 1, 1);
        
        box.pack_start (grid);
        box.pack_start (result_label);
        
        md5_entry.changed.connect (check_md5);
        iso_file_chooser.file_set.connect (set_file);
        
        w.set_size_request (250, 100);
        w.set_application (this);
        w.add (box);
        w.show_all ();
        
    }
        
    public override void activate () {}

    public void check_md5() {
     
        md5 = md5_entry.get_text();
        
        if (iso_file_chooser.get_file() != null && md5 != "") {
        
            if ( md5 == file_md5 ) {
                result_label.set_text("MD5 matches!");
            }  else {
                result_label.set_text("MD5 do not match!");
            }

        }
    }
    
    public void set_file() {
    
        string file = iso_file_chooser.get_filename();
        
        uint8[] contents;
        try {
            FileUtils.get_data(file, out contents);
        } catch (FileError e) { stdout.printf("%s/n", e.message); }
        string md5 = Checksum.compute_for_data(ChecksumType.MD5, contents);
        
        file_md5 = md5;
        
        check_md5();
    
    }
    
}

public static int main (string [] args) {
    Gtk.init (ref args);
    return new MD5Checker ().run (args);
}
