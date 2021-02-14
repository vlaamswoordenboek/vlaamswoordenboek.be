class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.column :title, :string
      t.column :body, :text
    end
    
    f = Forum.new( :title => 'Vlaams', 
      :body => 'Discussie over het Vlaams, de Vlaamse taal, Vlaamse taalgebruiken, ... Is het Vlaams wel een goede benaming voor de 
      taal die in Vlaanderen wordt gesproken? Vindt ge het gebruik van verbuigingen, "ge" en "gij", dubbelklanken goed of fout? Is het 
      Vlaams te versplinterd in te veel dialecten om een woordenboek te kunnen samenstellen? Breng uw mening hier ten berde.' )
    f.save!
    
    f = Forum.new( :title => 'Het Vlaams woordenboek', 
      :body => 'Wat denkt ge van deze web site? Wat kan er verbeterd worden aan de manier waarop het Vlaams woordenboek 
      is ingericht? Zijt ge een bug tegengekomen en wilt ge die ergens rapporteren? Andere suggesties of opmerkingen? Uit ze hier.' )
    f.save!
    
    f = Forum.new( :title => 'Allerlei', 
      :body => 'Discussie over allerlei andere dingen, die in de verte toch iets met (de Vlaamse of Nederlandse) taal te maken hebben.' )
    f.save!
    
  end

  def self.down
    drop_table :forums
  end
end
