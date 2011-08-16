require File.expand_path('spec_helper', File.dirname(__FILE__))

describe 'group' do
  before :all do
    Sunspot.remove_all
    @posts = []
    @posts << Post.new(:body => 'And the fox laughed', :author_name => "ram", :title => "A")
    @posts << Post.new(:body => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit fox ', :author_name => "ram", :title => "B")
    @posts << Post.new(:body => 'Blog 4 fox ', :author_name => "raghu", :title => "C")
    Sunspot.index!(*@posts)
  end

  it 'should return one result for each group' do
    search_result = Sunspot.group_search(Post) do
      group do
        field :author_name
        order_by :title, :desc
        limit 1
      end
    end
    search_result.results.should == {'ram' => [@posts[1]], 'raghu' => [@posts[2]]}
  end

  it 'should return all posts' do
    search_result = Sunspot.group_search(Post) do
      group do
        field :author_name
        order_by :title, :asc
        limit 5
      end
    end
    search_result.results.should == {'ram' => [@posts[0],@posts[1]], 'raghu' => [@posts[2]]}
  end

  it 'should work with pagination' do
    search_result = Sunspot.group_search(Post) do
      group do
        field :author_name
        order_by :title, :desc
        limit 1
      end
      paginate(:page => 2, :per_page => 1)
    end
    search_result.results.should == { 'raghu' => [@posts[2]] }
  end
end
